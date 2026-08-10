import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: (process.env.ALLOWED_ORIGINS || 'https://calm-bush-0efc41010.7.azurestaticapps.net')
      .split(',')
      .map((origin) => origin.trim()),
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    credentials: true,
  });
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(process.env.PORT || 3000);
  console.log(`api is running on: ${await app.getUrl()}`);
}
bootstrap();
