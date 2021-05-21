// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import './Owned.sol';

contract Students is Owned{

  // STRUCT AND VARS
  struct Student{
    uint id; //uint256
    string name;
    uint8 report; //0 = NA/ uninitialised, 1= fail, 2 = pass
  }

  uint private id;
  address private maintainer;
  mapping(uint => Student) private studentReport;
  mapping(address => uint) private studentToIdMapping;

  event ReportUpdated(uint id, Student student);
  event StudentRegistered(uint id, Student student);
  event MaintainerUpdated(address maintainer);

  // MODIFIERS
  // Use tx.origin, if we want maintainer person instead of maintainer contract
  modifier onlyMaintainer(){
    require(msg.sender == maintainer, "You are not allowed to update student report");
    _;
  }

  // CONSTRUCTOR AND FUNCTIONS

  constructor() Owned(){
    maintainer = msg.sender; // Initially owner is maintainer
  }

  function registerStudent(string memory name) payable public {
    // As per date this approx 2000 INR. Not an appropriate method though
    require(msg.value == 6900000 gwei, "Fees is not appropriate");
    uint _id = ++id;
    Student memory student = Student(_id, name, 0);
    studentReport[_id] = student;
    studentToIdMapping[msg.sender] = _id;
    emit StudentRegistered(_id, student);
  }

  function setReportOwner(address _maintainer) public onlyOwner {
    maintainer = _maintainer;
    emit MaintainerUpdated(maintainer);
  }

  function setStudentReport(uint256 _id, uint8 report) public onlyMaintainer{
    studentReport[_id].report = report;
    emit ReportUpdated(_id, studentReport[_id]);
  }

  function fetchMyReport() public view returns(Student memory){
    return studentReport[studentToIdMapping[msg.sender]];
  }

  function totalRegisteredStudent() public view returns(uint) {
    return id;
  }
  
  function transferFeesToOwner() public onlyOwner{
      address payable ownerAddress = payable(owner);
      ownerAddress.transfer(address(this).balance);
  }

}