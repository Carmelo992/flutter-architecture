class ModelUtils {
  static T parse<T>(dynamic data, T defaultValue) {
    if (data is T) return data;
    return defaultValue;
  }
}
