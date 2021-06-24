"use strict";

const { BLOCKS } = require("@contentful/rich-text-types");
const { documentToHtmlString } = require("@contentful/rich-text-html-renderer");

const getVideo = (post) => {
  if (post.fields.video && post.fields.video.ready) {
    return `https://stream.mux.com/${post.fields.video.playbackId}.m3u8`;
  }

  return null;
};

const options = {
  renderNode: {
    [BLOCKS.EMBEDDED_ASSET]: ({ data }) =>
      `<img title="${data.target.fields.title}" alt="${data.target.fields.description}" src="${data.target.fields.file.url}"/>`,
  },
};

const listArticles =
  ({ contentful }) =>
  async ({ page = 1, pageSize = 10 }) => {
    let { items } = await contentful.getEntries({
      skip: (page - 1) * pageSize,
      limit: pageSize,
      order: "-sys.updatedAt",
      content_type: "blogPost",
    });

    return items.map((post) => ({
      title: post.fields.title,
      body: documentToHtmlString(post.fields.body, options),
      preview: documentToHtmlString(getPreview(post.fields.body), options),
      updatedAt: post.sys.updatedAt,
      author: "CIP",
      video: getVideo(post),
    }));
  };

const getPreview = (body) => {
  const previewContent = body.content
    .filter((element) => element.nodeType == BLOCKS.PARAGRAPH)
    .slice(0, 1);

  const images = body.content.filter(
    (element) => element.nodeType == BLOCKS.EMBEDDED_ASSET
  );

  if (images.length) {
    previewContent.push(images[0]);
  }

  return Object.assign({}, body, { content: previewContent.reverse() });
};

module.exports = (deps) => listArticles(deps);
