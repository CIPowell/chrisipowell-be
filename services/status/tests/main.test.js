const { handler } = require('../src/index');

describe('Status Endpoint', () => {
    it('Should normally return OK', async () => {
        expect(await handler()).toEqual({ 
            statusCode: "200",
            body: "{ \"status\":\"OK\" }",
            headers: {} 
        })
    });
})