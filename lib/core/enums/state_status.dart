enum StateStatus {
  initial,
  loading,
  success,
  failure,

  //forPassword
  loaded, 
  correct,
  wrong;

  bool get isLoading => this == StateStatus.loading;
  bool get isSuccess => this == StateStatus.success;
  bool get isFailure => this == StateStatus.failure;
  bool get isInitial => this == StateStatus.initial;
  bool get isCorrect => this == StateStatus.correct;
  bool get isWrong => this == StateStatus.wrong;
  bool get isLoaded => this == StateStatus.loaded;
}
