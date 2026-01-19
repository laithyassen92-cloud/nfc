import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/students_repository.dart';
import '../../domain/models/student.dart';
import '../../domain/models/paginated_response.dart';
import '../../domain/requests/save_student_request.dart';
import '../../domain/requests/student_filter.dart';
import '../../domain/requests/delete_request.dart';
import '../datasources/students_data_source.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final StudentsDataSource dataSource;

  StudentsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, PaginatedResponse<Student>>> getStudents({
    required int page,
    required int pageSize,
    StudentFilter? filter,
  }) {
    return dataSource.getStudents(
      page: page,
      pageSize: pageSize,
      filter: filter,
    );
  }

  @override
  Future<Either<Failure, Student>> getStudentById(int id) {
    return dataSource.getStudentById(id);
  }

  @override
  Future<Either<Failure, Student>> createStudent(SaveStudentRequest request) {
    return dataSource.createStudent(request);
  }

  @override
  Future<Either<Failure, Student>> updateStudent(
    int id,
    SaveStudentRequest request,
  ) {
    return dataSource.updateStudent(id, request);
  }

  @override
  Future<Either<Failure, void>> deleteStudent(DeleteRequest request) {
    return dataSource.deleteStudent(request);
  }

  @override
  Future<Either<Failure, List<Student>>> searchStudents(String query) {
    return dataSource.searchStudents(query);
  }
}
