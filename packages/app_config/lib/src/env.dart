enum Env { dev, stage, prod }

extension EnvX on Env {
  String get name => switch (this) {
    Env.dev => 'dev',
    Env.stage => 'stage',
    Env.prod => 'prod',
  };
}
