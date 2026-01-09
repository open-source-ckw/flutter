const String userSignIn = """
  mutation(\$provider: String!, \$app_id: String){
    sign_in_user(input: {provider: \$provider, app_id: \$app_id}){
      token
      user{
        name
      }
    }
  }
""";
