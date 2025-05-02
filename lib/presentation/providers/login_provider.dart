import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_app/services/api_services.dart';

class LoginState {
  final String token;
  final bool isLoading;
  final String errorMessage;

  LoginState({this.token = '', this.isLoading = false, this.errorMessage = ''});

  LoginState copywith({
    String? token,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
    );
  }
}

class LoginProvider extends StateNotifier<LoginState> {
  final ApiServices apiServices;

  LoginProvider(this.apiServices) : super(LoginState());

  Future<void> login(String username, String password) async {
    state = state.copywith(isLoading: true, errorMessage: '');

    try {
      final token = await apiServices.login(username, password);
      state = state.copywith(isLoading: false, token: token);
    } catch (e) {
      state = state.copywith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final loginProvider = StateNotifierProvider<LoginProvider, LoginState>(
  (ref) => LoginProvider(ApiServices()),
);
