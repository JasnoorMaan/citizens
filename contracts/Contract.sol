// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Voters {
   struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address owner;
    mapping(address => bool) public voters;

    uint256 public votingStart;
    uint256 public votingEnd;

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
    }
    owner = msg.sender;
    votingStart = block.timestamp;
    votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
}

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                voteCount: 0
        }));
    }
    //THIS IS REQD
    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }
    //THIS IS REQD
    function getAllVotesOfCandiates() public view returns (Candidate[] memory){
        return candidates;
    }
    //THIS IS REQD
    function getVotingStatus() public view returns (bool) {
        return (block.timestamp >= votingStart && block.timestamp < votingEnd);
    }
    //THIS IS REQD
    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
    }
    function getWinner() public view returns (string memory winnerName, uint256 totalVotes){
        require(candidates.length > 0, "No candidate available.");

        uint256 maxVotes = 0;
        uint256 winnerIndex = 0;

        for(uint256 i = 0; i < candidates.length; i++){
            if(candidates[i].voteCount > maxVotes){
                maxVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }
        winnerName = candidates[winnerIndex].name;
        totalVotes = candidates[winnerIndex].voteCount;
    }
}