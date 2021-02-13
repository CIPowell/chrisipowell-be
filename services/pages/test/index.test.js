const { IoT1ClickDevicesService } = require('aws-sdk');
const { handler } = require('../lib/index');

it("should dry run", () => {
    handler({}, {});
});