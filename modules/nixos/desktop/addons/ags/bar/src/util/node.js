export const getWindow = (widget) => {
  let parent = widget;

  while (parent.parent) {
    parent = parent.parent;
  }

  return parent;
};
