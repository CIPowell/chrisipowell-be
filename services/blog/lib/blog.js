'use strict';

const listArticles = ({ contentful }) => async({page = 1, pageSize = 10}) => {
    let entries = contentful.getEntries({
        skip: (page - 1) * pageSize,
        limit: pageSize,
        order: 'sys.updatedAt',
        content_type: 'blog_entry'
    });

    return entries;
}
    


module.exports = deps => listArticles(deps);
