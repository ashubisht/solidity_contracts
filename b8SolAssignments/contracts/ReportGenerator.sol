// SPDX-License-Identifier: UNLICENCED;
pragma solidity ^0.8.3;

import "./Owned.sol";
import "./Marks.sol";

contract ReportGenerator is Owned{

  address private studentContractAddress;
  address private marksContractAddress;

  Marks private marks;

  event AddressUpdated(address _studentContractAddress, address _marksContractAddress);
  event ReportUpdated();
  event ErrorInvokeRaw(bytes reason);

  function initAddress(address _studentContractAddress, address _marksContractAddress) public onlyOwner{
    studentContractAddress = _studentContractAddress;
    marksContractAddress = _marksContractAddress;
    emit AddressUpdated(_studentContractAddress, _marksContractAddress);
  }

  // How to ensure caller sends enough gas for this?
  // How to avoid loops in such a condition. Any require to chck gas submitted than just ether value submitted?
  function updateStudentReport() public onlyOwner {
    // Trying two ways to call the contract, just for fun!! One where I dont have abi so I use encode, another where I have abi and 
    // thus, import the contract directly
    (bool success, bytes memory data) = studentContractAddress.call(abi.encodeWithSignature("totalRegisteredStudent()"));
    if(!success){
      revert("Unable to communicate with Students contract");
    }
    uint totalStudentsRegistered = abi.decode(data, (uint));
    require(totalStudentsRegistered >0, "No students have registered yet");

    marks = Marks(marksContractAddress);
    uint totalStudentsMarked = marks.totalStudentsMarked();
    
    require(totalStudentsMarked == totalStudentsRegistered, "All students haven't been marked yet!");

    for(uint256 i =0; i<=totalStudentsMarked; i++){
      uint8 studentMarks = marks.studentMarks(i);
      uint8 reportMarks = 0;
      if(studentMarks < 33){
        reportMarks = 1;
      }else{
        reportMarks = 2;
      }
      // Update report marks at Student contract
      (success, data) = studentContractAddress.call(abi.encodeWithSignature("setStudentReport(uint256,uint8)", i, reportMarks));
      if(!success){
        emit ErrorInvokeRaw(data);
        // revert(string(abi.encodePacked("Error in setting marks for student id: ", i)));
      }
    }
    emit ReportUpdated();
  }
}
