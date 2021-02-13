const { documentToHtmlString } = require('@contentful/rich-text-html-renderer');

const listPages = ({ contentful }) => async (parentSlug = "") => {
    let fieldQuery = 'fields.parent';
    let fieldValue = parentSlug;

    if (!parentSlug) {
        fieldQuery = 'fields.parent[exists]',
        fieldValue = false;
    }

    let { items } = await contentful.getEntries({
        order: 'sys.updatedAt',
        content_type: 'page',
        [fieldQuery]: fieldValue
    });

    return items.map(item =>({
        slug: item.fields.slug,
        title: items.fields.title
    }));
}

const getPage = ({ contentful }) => async (slug) => {
    let { items } = await contentful.getEntries({
        order: 'sys.updatedAt',
        content_type: 'page',
        'fields.slug': slug
    });

    return items.map(item =>({
        slug: item.fields.slug,
        title: items.fields.title,
        content: documentToHtmlString(items.content),
        parent: {
            slug: item.fields.parent.slug,
            title: item.fields.title
        }
    }));
}

module.exports = deps = {listPages: listPages(deps), getPage: getPage(deps)};