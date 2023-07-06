export class ConfigService {
  private readonly envConfig: { [key: string]: any } = null;

  constructor() {
    this.envConfig = {
      port: 3005,
      emailsDisabled: false,
    };
  }

  get(key: string): any {
    return this.envConfig[key];
  }
}
