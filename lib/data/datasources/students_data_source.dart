import '../../core/http_client_helper.dart';
import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/api_constants.dart';
import '../../domain/models/student.dart';
import '../../domain/models/paginated_response.dart';
import '../../domain/requests/save_student_request.dart';
import '../../domain/requests/student_filter.dart';
import '../../domain/requests/delete_request.dart';

class StudentsDataSource {
  final HttpClientHelper httpClient;
  final String? authToken;

  StudentsDataSource({required this.httpClient, this.authToken});

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<Either<Failure, PaginatedResponse<Student>>> getStudents({
    required int page,
    required int pageSize,
    StudentFilter? filter,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      if (filter != null) ...filter.toQueryParams(),
    };

    final result = await httpClient.get(
      ApiConstants.studentsEndpoint,
      headers: _headers,
      queryParameters: queryParams,
    );

    return result.map(
      (data) => PaginatedResponse.fromJson(
        data,
        (json) => Student.fromJson(json as Map<String, dynamic>),
      ),
    );
  }

  Future<Either<Failure, Student>> getStudentById(int id) async {
    final result = await httpClient.get(
      '${ApiConstants.studentsEndpoint}/$id',
      headers: _headers,
    );

    return result.map((data) => Student.fromJson(data));
  }

  Future<Either<Failure, Student>> createStudent(
    SaveStudentRequest request,
  ) async {
    final result = await httpClient.post(
      ApiConstants.studentsEndpoint,
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => Student.fromJson(data));
  }

  Future<Either<Failure, Student>> updateStudent(
    int id,
    SaveStudentRequest request,
  ) async {
    final result = await httpClient.put(
      '${ApiConstants.studentsEndpoint}/$id',
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => Student.fromJson(data));
  }

  Future<Either<Failure, void>> deleteStudent(DeleteRequest request) async {
    final result = await httpClient.delete(
      ApiConstants.studentsEndpoint,
      headers: _headers,
      body: request.toJson(),
    );

    return result.map((_) => null);
  }

  Future<Either<Failure, List<Student>>> searchStudents(String query) async {
    final result = await httpClient.get(
      ApiConstants.studentsEndpoint,
      headers: _headers,
      queryParameters: {'search': query},
    );

    return result.map((data) {
      final list = data['items'] as List? ?? data['data'] as List? ?? [];
      return list
          .map((item) => Student.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
