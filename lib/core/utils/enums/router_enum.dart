enum AppRouterKeys {
  authRoute('/auth'),
  homeRoute('/home'),
  offlineRoute('/offline'),
  splashRoute('/');

  final String path;
  const AppRouterKeys(this.path);
}
