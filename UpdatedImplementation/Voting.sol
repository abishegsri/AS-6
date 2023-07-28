
pragma solidity ^0.8.14;
import "@openzeppelin/contracts/access/Ownable.sol";
import {VotingToken} from "./token.sol";
contract Voting is Ownable
{
    mapping (address=>bytes32) voterCommit;
    mapping (string=>uint) voteCasted;
        struct Candidate
    {
        string Candidatename;
    }
    Candidate [] candidates;
    VotingToken instance;
    mapping (address => bool) revelMade;
    mapping (address => uint) tokensStacked;
    constructor(string[] memory _candidatelist,address deployed_add) 
    {
        //list of predefined candidates as mentioned in the problem statement
        for(uint i=0;i<_candidatelist.length;i++)
        {
            candidates.push(Candidate(_candidatelist[i]));
        }
        instance=VotingToken(deployed_add);
    }
    event commitCreated(address _sender,bytes32 _commitmade);
    event revealMade(string _name,string  _salt,address _sender);
    event votingCompleted();
    enum Stage{commit,reveal}
    Stage stage=Stage.commit;
    mapping (address => bool) _isaddressVoted;
    function vote_commit(bytes32 cand) public 
    {
        require(stage==Stage.commit,"Voting is not completed");
        require(_isaddressVoted[msg.sender]==false,"Voter can vote only once");
        require(instance.balanceOf(msg.sender)>0,"NOt enough tokens to stack and vote");
        tokensStacked[msg.sender]=instance.balanceOf(msg.sender);
        instance._safeTransfer(msg.sender,address(this),instance.balanceOf(msg.sender));
        _isaddressVoted[msg.sender]=true;
        voterCommit[msg.sender]=cand;
        emit commitCreated(msg.sender,cand);
    }
    function revealVote(string memory name,string memory salt) public
    {
        require(stage==Stage.reveal);
        require(revelMade[msg.sender]==false,"You can comfirm your vote only Once");
        require(keccak256(abi.encodePacked(name,salt))==voterCommit[msg.sender]);
        revelMade[msg.sender]=true;
        voteCasted[name]+=instance.balanceOf(msg.sender);
        instance._safeTransfer(address(this),msg.sender,tokensStacked[msg.sender]);
        emit revealMade(name, salt, msg.sender);
    }
    function delecareWinner() onlyOwner public view returns(string memory)
    {
        require(stage==Stage.reveal,"Voting has not completed");
        uint length=candidates.length;
        uint maxVotes;
        string memory result;
        for(uint i=0;i<length;i++)
        {
           if(voteCasted[candidates[i].Candidatename]>maxVotes)
           {
               maxVotes=voteCasted[candidates[i].Candidatename];
               result=candidates[i].Candidatename;
           }
        }
        return result;
    }
    function giveHash(string memory name,string memory salt) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(name,salt));
    }
    function completeVoting() public onlyOwner
    {
        stage=Stage.reveal;
        emit votingCompleted();
    }
}
