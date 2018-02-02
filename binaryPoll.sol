pragma solidity ^0.4.19;

contract binaryPoll {
    address owner;
    address[] private voters;
    
    string private Question;
    bool votingOpen;
    uint256 bounty;
    
    struct option
    {
        string name;
        uint16 count;
    }
    option[2] votes;
    
    modifier onlyOwner() { require(msg.sender == owner); _; }
    
    function binaryPoll(string _question, string _opt1, string _opt2) payable {
        assert(msg.value > 0);
        bounty = msg.value;
        owner = msg.sender;
        Question = _question;
        votes[0].name = _opt1;
        votes[1].name = _opt2;
        votingOpen = true;
    }
    
    function vote(uint8 _choice) {
        assert(msg.sender != owner);
        assert(_choice < votes.length);
        assert(votingOpen);
        
        for (uint8 i = 0; i < voters.length; i++) 
        {
            if (voters[i] == msg.sender)
            revert();
        }
        
        votes[_choice].count = votes[_choice].count + 1;
        voters.push(msg.sender);
    }
    
    function getOptions() constant returns(string question,  string option0, string option1, 
    uint256 availableBounty, uint256 numVoters) {
        return(Question, votes[0].name, votes[1].name, bounty, voters.length);
    }
    
    function closePoll() onlyOwner {
        assert (votingOpen);
        votingOpen = false;
        
        for (uint i = 0; i < voters.length; i++) 
        {
            voters[i].transfer(bounty/voters.length);
        }
    }
    
    function getResults() returns (uint16 votes0, uint16 votes1) {
        assert (!votingOpen);
        return (votes[0].count, votes[1].count);
    }
    
}