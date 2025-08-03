class CheckCodAvailabilityUseCase {
  bool call(String district) {
    const allowed = ['kathmandu', 'lalitpur', 'bhaktapur'];
    return allowed.contains(district.toLowerCase());
  }
}