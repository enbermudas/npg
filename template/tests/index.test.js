import helloName from 'src'

describe('Main', () => {
  it('Should return a hello message', () => {
    const msg = helloName('Enrique');
    expect(msg).toEqual('Hello, Enrique!');
  });
});
