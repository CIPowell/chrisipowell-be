const { documentToHtmlString } = require('@contentful/rich-text-html-renderer');

const getPage = async (contentful, slug = "") => {
    let { items } = await contentful.getEntries({
        order: 'sys.updatedAt',
        content_type: 'page',
        'fields.slug[eq]': slug
    });
   
    return items.map(item =>({
        slug: item.fields.slug,
        title: item.fields.title,
        content: documentToHtmlString(item.fields.content),
        parent: {
            slug: item.fields.parent?.slug,
            title: item.fields.parent?.title
        }
    }));
}

const getRootLinks = async (contentful) => {
    let { items } = await contentful.getEntries({
        order: 'sys.updatedAt',
        content_type: 'page',
        'fields.parent[exists]': false
    });

    return items.map(item =>({
        slug: item.fields.slug,
        title: item.fields.title
    }));
}

const getChildPageLinks = async (contentful, slug) => {
    try {
        let { items } = await contentful.getEntries({
            content_type: 'page',
            'fields.parent.sys.contentType.sys.id': 'page',
            'fields.parent.fields.slug[eq]': slug
        });

        return items
            .filter(item => item.fields.slug != slug)
            .map(item =>({
                slug: item.fields.slug,
                title: item.fields.title
            }));
    } catch (err) {
        console.error(err);
    }

    return {};
}

const listPages = ({ contentful }) => async (slug = "") => {
    if (!slug) {
        return { links: await getRootLinks(contentful), content: {} };
    }

    return { 
        links: await getChildPageLinks(contentful, slug),
        content: await getPage(contentful, slug)
    }
}



module.exports = deps => ({listPages: listPages(deps)});