// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ballot.sol";

contract BallotTest is Test {
    Ballot public ballot;
    bytes32[] proposalNames = [bytes32("A"), bytes32("B"), bytes32("C")];
    address[] newVoters = [address(0), address(1), address(2)];

    function setUp() public {
        ballot = new Ballot(proposalNames);
    }

    function testChairpersonSetUp() public {
        assertEq(ballot.chairperson(), address(this));
    }

    function testGiveRightToVote() public {
        ballot.giveRightToVote(address(10));
        (uint256 weight,,,) = ballot.voters(address(10));
        assertEq(weight, 1);
    }

    function testGiveViteRightsToMany() public {
        ballot.giveVoteRightsToMany(newVoters);
        (uint256 weight0,,,) = ballot.voters(address(0));
        (uint256 weight1,,,) = ballot.voters(address(1));
        (uint256 weight2,,,) = ballot.voters(address(2));
        assertEq(weight0, 1);
        assertEq(weight1, 1);
        assertEq(weight2, 1);
    }
}

contract BallotVotingTest is Test {
    Ballot public ballot;
    bytes32[] proposalNames = [bytes32("A"), bytes32("B"), bytes32("C")];
    address[] newVoters = [address(0), address(1), address(2)];

    function setUp() public {
        ballot = new Ballot(proposalNames);
        ballot.giveVoteRightsToMany(newVoters);
    }

    function testVoting() public {
        vm.prank(newVoters[0]);
        ballot.vote(0);

        vm.prank(newVoters[1]);
        ballot.vote(1);

        vm.prank(newVoters[2]);
        ballot.vote(2);

        uint256[] memory winningProposals = ballot.winningProposals();

        assertEq(winningProposals.length, 3);
    }
}
