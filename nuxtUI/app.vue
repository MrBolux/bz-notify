<template>
  <div>
    <UNotifications :ui="{ position: config.position }" />
    <!-- <UButton label="Show toast" @click="handleMessageListener(notifContent)" /> -->
    <UButton label="Show toast" @click="handleMessageListener(notifContent)" />

    <!-- <UButton
      label="Show toast"
      @click="toast.add({ title: 'Expires soon...', timeout: 1000, callback: onCallback })"
    /> -->
  </div>
</template>

<script setup lang="ts">
function onCallback() {
  alert("Notification expired!");
}

const toast = useToast();
const colorMode = useColorMode();

const config = ref({
  position: "top-right",
  darkMode: true,
  sound: {
    playSound: true,
    volume: 0.8,
  },
});

const actions = ref([
  {
    label: "Yes",
    event: "hospital:client:Revive",
    side: "client",
    parameters: {},
  },
  {
    label: "No",
    event: "",
    side: "",
    parameters: {},
  },
]);

const notifContent = {
  // data: {
  //   type: "notify",
  //   content: {
  //     icon: "arrow-down-right",
  //     color: "primary",
  //     description: "Nous somme ouvert !",
  //     timeout: 0,
  //     title: "LsCustom",
  //     actions: actions.value,
  //     // sound: "custom.mp3",
  //   },
  // },
  data: {
    type: "requestNotify",
    content: {
      icon: "arrow-down-right",
      color: "primary",
      description: "Nous somme ouvert !",
      timeout: 10000,
      title: "LsCustom",
      actions: actions.value,
      // sound: "custom.mp3",
    },
  },
};

// Fonction pour jouer un son
const playSound = (soundPath: string, volume = config.value.sound.volume) => {
  const sound = new Audio(soundPath);
  sound.volume = volume;
  sound.play();
};

const closeUi = (response) => {
  fetch(`https://bz-notify/request_notif_result`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({
      response: response,
    }),
  });
};

const handleMessageListener = (event) => {
  if (!event?.data) return;

  const content = { ...event.data.content };

  // Assurer un timeout par défaut
  content.timeout = content.timeout || 5000;

  // Vérifier et mettre à jour l'avatar si nécessaire
  if (content.avatar) {
    content.avatar = { src: `./image/${content.avatar}`, size: "2xl" };
  }

  if (content.icon) {
    content.icon = `i-heroicons-${content.icon}`;
  }

  if (content.sound) {
    playSound(`./sound/${content.sound}`);
  } else if (config.value.sound?.playSound) {
    playSound("./sound/default_pop_up.mp3", config.value.sound.volume);
  }

  // Transformation des actions
  if (Array.isArray(content.actions)) {
    content.actions = content.actions.map((item) => ({
      label: item.label,
      click: () =>
        closeUi({
          event: item.event,
          side: item.side,
          parameters: item.parameters,
        }),
    }));
    // Définir le callback pour fermer l'UI
    content.callback = () => closeUi(false);
  }

  toast.add(content);
};

onMounted(() => {
  fetch("https://bz-notify/request_config").then((response) => {
    if (response.ok) {
      response.json().then((data) => {
        config.value = data;
        colorMode.preference = config.value.darkMode ? "dark" : "light";
        window.addEventListener("message", handleMessageListener);
      });
    } else {
      console.log("bz-notify: NUI error (could not fetch config)");
    }
  });
});

onUnmounted(() => {
  window.removeEventListener("message", handleMessageListener);
});
</script>

<style>
.dark {
  color-scheme: none !important;
}
</style>
