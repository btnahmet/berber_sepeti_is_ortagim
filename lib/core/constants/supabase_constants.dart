/// Supabase bağlantı yapılandırması.
///
/// ⚠️ ÖNEMLİ: Bu bilgileri Supabase Dashboard > Settings > API
/// sayfasından doğrulayabilirsiniz.
class SupabaseConstants {
  SupabaseConstants._();

  /// Supabase proje URL'si.
  static const String projectUrl =
      'https://bzplggwtwqrvahprcrlt.supabase.co';

  /// Supabase Anon (Public) Key.
  /// Bu anahtar istemci tarafında güvenle kullanılabilir.
  /// Row Level Security (RLS) ile korunur.
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6cGxnZ3d0d3FydmFocHJjcmx0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMxNjcwMTYsImV4cCI6MjA5ODc0MzAxNn0.CVAhmuETQduGVxgSefDfcrVo2NiPUNdSL6_2iI7pieo';
}
