const { handler } = require('../src/index');
const { version } = require('../package.json');

describe('Status Endpoint', () => {
    it('Should normally return OK', async () => {
        expect(await handler()).toEqual({ 
            statusCode: "200",
            body: `{ "status":"OK", "version": "${version}" }`,
            headers: {} 
        })
    });
})