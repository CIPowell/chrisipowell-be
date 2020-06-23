'use strict';

const { documentToHtmlString } = require('@contentful/rich-text-html-renderer');

const getVideo = (post) => {
    if (post.fields.video && post.fields.video.ready) {
        return `https://stream.mux.com/${post.fields.video.playbackId}.m3u8`;
    }

    return null;
}

const listArticles = ({ contentful }) => async({page = 1, pageSize = 10}) => {
    let { items } = await contentful.getEntries({
        skip: (page - 1) * pageSize,
        limit: pageSize,
        order: 'sys.updatedAt',
        content_type: 'blogPost'
    });

    return items.map(post => ({
        title: post.fields.title,
        body: documentToHtmlString(post.fields.body),
        updatedAt: post.sys.updatedAt,
        author: 'CIP',
        video: getVideo(post)
    }));
}
    
module.exports = deps => listArticles(deps);
