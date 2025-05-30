import '../mocks/mock_data.dart';

abstract class BaseService {
  Future<T> getData<T>({
    required String key,
    required Future<T> Function() fetchRealData,
  }) async {
    if (MockData.useMockData) {
      return MockData.mockData[key] as T;
    }
    return await fetchRealData();
  }

  Future<List<T>> getListData<T>({
    required String key,
    required Future<List<T>> Function() fetchRealData,
  }) async {
    if (MockData.useMockData) {
      return (MockData.mockData[key] as List).cast<T>();
    }
    return await fetchRealData();
  }
}
