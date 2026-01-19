import '../../core/either.dart';
import '../../core/failure.dart';
import '../models/student.dart';
import '../models/paginated_response.dart';
import '../requests/save_student_request.dart';
import '../requests/student_filter.dart';
import '../requests/delete_request.dart';

/// Repository interface for student operations
abstract class StudentsRepository {
  /// Get paginated list of students
  Future<Either<Failure, PaginatedResponse<Student>>> getStudents({
    required int page,
    required int pageSize,
    StudentFilter? filter,
  });

  /// Get student by ID
  Future<Either<Failure, Student>> getStudentById(int id);

  /// Create new student
  Future<Either<Failure, Student>> createStudent(SaveStudentRequest request);

  /// Update existing student
  Future<Either<Failure, Student>> updateStudent(
    int id,
    SaveStudentRequest request,
  );

  /// Delete student
  Future<Either<Failure, void>> deleteStudent(DeleteRequest request);

  /// Search students by name or code
  Future<Either<Failure, List<Student>>> searchStudents(String query);
}
