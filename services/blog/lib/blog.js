'use strict';

const { documentToHtmlString } = require('@contentful/rich-text-html-renderer');

const listArticles = ({ contentful }) => async({page = 1, pageSize = 10}) => {

    console.log("Getting entries")
    let { items } = await contentful.getEntries({
        skip: (page - 1) * pageSize,
        limit: pageSize,
        order: 'sys.updatedAt',
        content_type: 'blogPost'
    });

    console.log(items.length + ' entries');

    console.log(JSON.stringify(items, null, 4));

    return items.map(post => ({
        title: post.fields.title,
        body: documentToHtmlString(post.fields.body),
        updatedAt: post.sys.updatedAt,
        author: 'CIP'
    }));
}
    
module.exports = deps => listArticles(deps);
