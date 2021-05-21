// SPDX-License-Identifier: UNLICENCED;
pragma solidity ^0.8.3;

import "./Owned.sol";

contract Marks is Owned{

  mapping(uint => uint8) public studentMarks;
  uint public totalStudentsMarked;
  
  event MarksUpdated(uint id, uint8 marks);
  event TotalStudentsMarked(uint totalStudentsMarked);

  function setStudentMarks(uint id, uint8 marks) public onlyOwner {
    studentMarks[id] = marks;
    totalStudentsMarked++;
    emit MarksUpdated(id, marks);
    emit TotalStudentsMarked(totalStudentsMarked);
  }

}
