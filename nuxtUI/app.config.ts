export default defineAppConfig({
  ui: {
    icons: {
      dynamic: true,
    },
    notification: {
      title: "text-lg font-semibold",
      description: "font-semibold dark:text-gray-300",
      default: {
        closeButton: {
          icon: "",
        },
      },
      icon: {
        base: "self-center",
      },
    },
    notifications: {
      position: "",
    },
  },
});
