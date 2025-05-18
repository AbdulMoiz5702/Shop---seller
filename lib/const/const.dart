export './colors.dart';
export './lists.dart';
export './strings.dart';
export 'package:velocity_x/velocity_x.dart';
export 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AppConstants {
  // Database credentials
  static const String dbPassword = 'TI1ddDf9yRbffkKX';
  static const String supaBaseUrl = 'https://vmjdkyrwhejyzzqogrqg.supabase.co';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZtamRreXJ3aGVqeXp6cW9ncnFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM4MzUwMjcsImV4cCI6MjA1OTQxMTAyN30.cJFBUoj9pIV21VOpWAlGAPLEVQixqI2oaE08FsOckoc';
  static const webClientId = '440715591058-7ofr6oe63mqlerogb5mqufr8juo5eej1.apps.googleusercontent.com';
  // Supabase client
  static final SupabaseClient supaBase = Supabase.instance.client;

  // Buckets
  static const String firebaseBucket = 'firebase.bucket';
  static const String pictures = 'pictures';



}
