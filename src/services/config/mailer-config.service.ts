import {
  MailerOptionsFactory,
  MailerOptions,
  HandlebarsAdapter,
} from '@nest-modules/mailer';

export class MailerConfigService implements MailerOptionsFactory {
  createMailerOptions(): MailerOptions {
    return {
      transport: {
        service: 'gmail',
        // host: 'smtp.google.com',
        // port: 465,
        secure: false,
        auth: {
          user: 'khalil.chettaoui06@gmail.com',
          pass: 'txgqsemqxrdhdpow',
        },
      },
      defaults: {
        from: 'khalil.chettaoui06@gmail.com',
      },
      template: {
        adapter: new HandlebarsAdapter(), // or new PugAdapter() or new EjsAdapter()
        options: {
          strict: true,
        },
      },
    };
  }
}
