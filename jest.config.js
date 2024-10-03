/** @type {import('ts-jest').JestConfigWithTsJest} **/
export default {
  clearMocks: true,
  preset: 'ts-jest',
  testEnvironment: 'node',
  setupFilesAfterEnv: ['./singleton.ts'],
};