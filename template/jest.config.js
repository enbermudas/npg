module.exports = {
  collectCoverage: true,
  collectCoverageFrom: ['src/**/*.js', '!data/keyMap.js', '!/node_modules/'],
  clearMocks: true,
  testEnvironment: 'node',
  coveragePathIgnorePatterns: ['/node_modules/', '/coverage/'],
};
