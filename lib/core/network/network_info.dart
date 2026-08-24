abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For simplicity in this dummy environment, we assume connected.
    // In a real app, use connectivity_plus.
    return true;
  }
}
