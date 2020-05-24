'use strict';

const blog = require('../lib/blog');

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
    });

    it('Should request a list of blog articles', async () => {
        contentful.getEntries.mockReturnValue({ items: [{}, {}, {}] });

        let { items } = await handler({});

        expect(contentful.getEntries.mock.calls.length).toBe(1);

        let [{skip, limit, order, content_type}] = contentful.getEntries.mock.calls[0];

        expect(skip).toBe(0);
        expect(limit).toBe(10);
        expect(order).toBe('sys.updatedAt');
        expect(content_type).toBe('blog_entry');

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
});
