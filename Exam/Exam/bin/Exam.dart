import 'dart:convert';
import 'dart:io';

// Function to display all students
void displayAllStudents() async {
  final file = File('Student.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  for (var student in data['students']) {
    print('ID: ${student['id']}');
    print('Name: ${student['name']}');
    for (var subject in student['subjects']) {
      print('  Subject: ${subject['name']}');
      print('  Scores: ${subject['scores']}');
    }
  }
}

// Function to add a new student
void addStudent() async {
  final file = File('Student.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  print('Enter Student ID:');
  int id = int.parse(stdin.readLineSync()!);
  
  print('Enter Student Name:');
  String name = stdin.readLineSync()!;
  
  List<Map<String, dynamic>> subjects = [];
  print('Enter number of subjects:');
  int numSubjects = int.parse(stdin.readLineSync()!);
  
  for (int i = 0; i < numSubjects; i++) {
    print('Enter subject name:');
    String subjectName = stdin.readLineSync()!;
    
    print('Enter scores for $subjectName (comma-separated):');
    List<int> scores = stdin.readLineSync()!.split(',').map(int.parse).toList();
    
    subjects.add({
      'name': subjectName,
      'scores': scores,
    });
  }
  
  data['students'].add({
    'id': id,
    'name': name,
    'subjects': subjects,
  });
  
  final updatedJsonString = jsonEncode(data);
  await file.writeAsString(updatedJsonString);
  print('Student added successfully!');
}

// Function to edit a student's information
void editStudent() async {
  final file = File('Student.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  print('Enter Student ID to edit:');
  int id = int.parse(stdin.readLineSync()!);
  
  var student = data['students'].firstWhere((s) => s['id'] == id, orElse: () => null);
  
  if (student == null) {
    print('Student not found.');
    return;
  }
  
  print('Edit Name (current: ${student['name']}):');
  String name = stdin.readLineSync()!;
  if (name.isNotEmpty) {
    student['name'] = name;
  }

  // Prompt user for changes, then update the student object.
  
  final updatedJsonString = jsonEncode(data);
  await file.writeAsString(updatedJsonString);
  print('Student information updated successfully!');
}

// Function to search for a student by ID or Name
void searchStudent() async {
  final file = File('Student.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  print('Search by (1) ID or (2) Name?');
  int choice = int.parse(stdin.readLineSync()!);
  
  if (choice == 1) {
    print('Enter ID:');
    int id = int.parse(stdin.readLineSync()!);
    var student = data['students'].firstWhere((s) => s['id'] == id, orElse: () => null);
    if (student != null) {
      print('ID: ${student['id']}');
      print('Name: ${student['name']}');
      for (var subject in student['subjects']) {
        print('  Subject: ${subject['name']}');
        print('  Scores: ${subject['scores']}');
      }
    } else {
      print('Student not found.');
    }
  } else if (choice == 2) {
    print('Enter Name:');
    String name = stdin.readLineSync()!;
    var students = data['students'].where((s) => s['name'].toLowerCase().contains(name.toLowerCase())).toList();
    if (students.isNotEmpty) {
      for (var student in students) {
        print('ID: ${student['id']}');
        print('Name: ${student['name']}');
        for (var subject in student['subjects']) {
          print('  Subject: ${subject['name']}');
          print('  Scores: ${subject['scores']}');
        }
      }
    } else {
      print('No students found with that name.');
    }
  } else {
    print('Invalid choice.');
  }
}

// Main function to display menu and call appropriate functions
void main() {
  while (true) {
    print('\nStudent Management System');
    print('1. Display All Students');
    print('2. Add Student');
    print('3. Edit Student');
    print('4. Search Student');
    print('5. Exit');
    print('Enter your choice:');
    
    int choice = int.parse(stdin.readLineSync()!);
    
    switch (choice) {
      case 1:
        displayAllStudents();
        break;
      case 2:
        addStudent();
        break;
      case 3:
        editStudent();
        break;
      case 4:
        searchStudent();
        break;
      case 5:
        exit(0);
      default:
        print('Invalid choice. Please try again.');
    }
  }
}
