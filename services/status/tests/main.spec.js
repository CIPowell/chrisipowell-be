const { handler } = require('../src/index');

describe('Status Endpoint', () => {
    it('Should normally return OK', () => {
        expect(handler()).toEqual({
            'status': 'OK'
        })
    });
})