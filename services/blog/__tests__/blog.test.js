'use strict';

const blog = require('../lib/blog');
const testEntry = require('./testEntry.json');

describe('Listing Blog articles', () => {
    let contentful;
    let handler;
    let logger;

    beforeEach(() => {
        contentful = {
            getEntries: jest.fn()
        };
        logger = {};
        handler = blog({ contentful, logger });

        contentful.getEntries.mockReturnValue({ items: [testEntry, testEntry, testEntry] });
    });

    it('Should request a list of blog articles', async () => {
        let items = await handler({});

        expect(contentful.getEntries.mock.calls.length).toBe(1);

        let [{skip, limit, order, content_type}] = contentful.getEntries.mock.calls[0];

        expect(skip).toBe(0);
        expect(limit).toBe(10);
        expect(order).toBe('sys.updatedAt');
        expect(content_type).toBe('blogPost');

        expect(items.length).toBe(3);
    });

    it.each`
        page        | pageSize      | expLimit | expSkip
        ${1}        | ${10}         | ${10}    | ${0}
        ${2}        | ${10}         | ${10}    | ${10}
        ${10}       | ${20}         | ${20}    | ${180}
        ${1}        | ${undefined}  | ${10}    | ${0}
        ${undefined}| ${1000}       | ${1000}  | ${0}
    `('Should request $expLimit entries, skipping $expSkip when asking for page $page with a pagesize of $pageSize', async ({
        page,
        pageSize,
        expLimit,
        expSkip
    }) => {
        await handler({page, pageSize});

        let [{skip, limit}] = contentful.getEntries.mock.calls[0];

        expect(skip).toBe(expSkip);
        expect(limit).toBe(expLimit);
    });

    it('Should transform articles correctly', async () => {
        let items = await handler({});

        items.forEach(({ title, preview, body, updatedAt, author, video }) => {
            expect(title).toBe('Hello world!');
            expect(body).toBe('<p>My First Blog Post</p><p>More text...</p>')
            expect(preview).toBe('<p>My First Blog Post</p>');
            expect(updatedAt).toBe('2020-05-30T12:30:14.000Z')
            expect(author).toBe('CIP');
            expect(video).toBe(null);
        });
    });

    it('should return a url for the videof there is one', async () => {
        testEntry.fields.video = {
            "uploadId": "vQYGB02fw015bC01bPvpbzbUlOnY1y50148fdtclWuVvdmw",
            "assetId": "9tb2esatVoE7MpZnI44I2Vqh01XSCbX7a8x2AEohbPWk",
            "playbackId": "vdija4nm02TW5kleRaMld8XavCjaMDCSKGZfMjyKNfkA",
            "ready": true
        };

        let items = await handler({});

        items.forEach(({ video }) => {
            expect(video).toBe(`https://stream.mux.com/vdija4nm02TW5kleRaMld8XavCjaMDCSKGZfMjyKNfkA.m3u8`)
        });
    });
});
