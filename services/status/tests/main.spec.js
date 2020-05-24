const handler = require('../src/main');

describe('Status Endpoint', () => {
    it('Should normally return OK', () => {
        expect(handler()).toEqual({
            'status': 'OK'
        })
    });
})