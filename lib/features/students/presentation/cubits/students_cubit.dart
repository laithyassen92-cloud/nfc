import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/students_repository.dart';
import '../../domain/models/student.dart';
import '../../domain/models/paginated_response.dart';
import '../../domain/requests/save_student_request.dart';
import '../../domain/requests/student_filter.dart';
import '../../domain/requests/delete_request.dart';

// States
abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final PaginatedResponse<Student> students;

  const StudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentDetailsLoaded extends StudentsState {
  final Student student;

  const StudentDetailsLoaded(this.student);

  @override
  List<Object?> get props => [student];
}

class StudentsError extends StudentsState {
  final Failure failure;

  const StudentsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Cubit
class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepository repository;

  StudentsCubit({required this.repository}) : super(StudentsInitial());

  Future<void> loadStudents({
    int page = 1,
    int pageSize = 20,
    StudentFilter? filter,
  }) async {
    emit(StudentsLoading());

    final result = await repository.getStudents(
      page: page,
      pageSize: pageSize,
      filter: filter,
    );

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (students) => emit(StudentsLoaded(students)),
    );
  }

  Future<void> loadStudentById(int id) async {
    emit(StudentsLoading());

    final result = await repository.getStudentById(id);

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (student) => emit(StudentDetailsLoaded(student)),
    );
  }

  Future<void> createStudent(SaveStudentRequest request) async {
    emit(StudentsLoading());

    final result = await repository.createStudent(request);

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (student) => emit(StudentDetailsLoaded(student)),
    );
  }

  Future<void> updateStudent(int id, SaveStudentRequest request) async {
    emit(StudentsLoading());

    final result = await repository.updateStudent(id, request);

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (student) => emit(StudentDetailsLoaded(student)),
    );
  }

  Future<void> deleteStudent(DeleteRequest request) async {
    emit(StudentsLoading());

    final result = await repository.deleteStudent(request);

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (_) => emit(StudentsInitial()),
    );
  }

  Future<void> searchStudents(String query) async {
    emit(StudentsLoading());

    final result = await repository.searchStudents(query);

    result.fold(
      (failure) => emit(StudentsError(failure)),
      (students) => emit(
        StudentsLoaded(
          PaginatedResponse(
            data: students,
            totalCount: students.length,
            pageNumber: 1,
            pageSize: students.length,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        ),
      ),
    );
  }
}
