// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.21;


contract StudentRecords {

    struct StudentDetails {
        string name;
        string rollNumber; // unique
        string admissionCode;
        string fatherName;
        bool exists;
    }

    struct Marks {
        uint256 timestamp;
        uint8 subject1;
        uint8 subject2;
        uint8 subject3;
        uint8 subject4;
        uint8 subject5;
    }

    struct ActivityLog {
        uint256 timestamp;
        string activityType; // e.g. "Details Added", "Marks Added"
        string description;
    }

    // Mappings
    mapping(string => StudentDetails) private students; // rollNumber => StudentDetails
    mapping(string => Marks[]) private studentMarks; // rollNumber => Marks array
    mapping(string => ActivityLog[]) private studentLogs; // rollNumber => ActivityLog array

    // Events
    event StudentAdded(string rollNumber, string name, string admissionCode, string fatherName);
    event MarksAdded(string rollNumber, uint8 subject1, uint8 subject2, uint8 subject3, uint8 subject4, uint8 subject5);

    // Step 1: Add student details
    function addStudentDetails(
        string memory _name,
        string memory _rollNumber,
        string memory _admissionCode,
        string memory _fatherName
    ) public {
        require(!students[_rollNumber].exists, "Student already exists");

        students[_rollNumber] = StudentDetails({
            name: _name,
            rollNumber: _rollNumber,
            admissionCode: _admissionCode,
            fatherName: _fatherName,
            exists: true
        });

        // Add to logs
        studentLogs[_rollNumber].push(ActivityLog({
            timestamp: block.timestamp,
            activityType: "Details Added",
            description: string(abi.encodePacked("Student details added for ", _name))
        }));

        emit StudentAdded(_rollNumber, _name, _admissionCode, _fatherName);
    }

    // Step 2: Add student marks (can be called multiple times)
    function addStudentMarks(
        string memory _rollNumber,
        uint8 _subject1,
        uint8 _subject2,
        uint8 _subject3,
        uint8 _subject4,
        uint8 _subject5
    ) public {
        require(students[_rollNumber].exists, "Student does not exist");

        studentMarks[_rollNumber].push(Marks({
            timestamp: block.timestamp,
            subject1: _subject1,
            subject2: _subject2,
            subject3: _subject3,
            subject4: _subject4,
            subject5: _subject5
        }));

        // Add to logs
        studentLogs[_rollNumber].push(ActivityLog({
            timestamp: block.timestamp,
            activityType: "Marks Added",
            description: "Marks record added."
        }));

        emit MarksAdded(_rollNumber, _subject1, _subject2, _subject3, _subject4, _subject5);
    }

    // Step 3: View student details
    function getStudentDetails(string memory _rollNumber)
        public
        view
        returns (StudentDetails memory)
    {
        require(students[_rollNumber].exists, "Student does not exist");
        return students[_rollNumber];
    }

    // Get all marks records for a student
    function getStudentMarks(string memory _rollNumber)
        public
        view
        returns (Marks[] memory)
    {
        require(students[_rollNumber].exists, "Student does not exist");
        return studentMarks[_rollNumber];
    }

    // Get all activity logs (timeline) for a student
    function getStudentLogs(string memory _rollNumber)
        public
        view
        returns (ActivityLog[] memory)
    {
        require(students[_rollNumber].exists, "Student does not exist");
        return studentLogs[_rollNumber];
    }
}
