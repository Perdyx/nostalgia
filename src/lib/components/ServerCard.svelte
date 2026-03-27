<script context="module">
  // Global queue shared across all instances of ServerCard
  let requestQueue = [];
  let isProcessing = false;

  async function processQueue() {
    if (isProcessing || requestQueue.length === 0) return;
    isProcessing = true;

    while (requestQueue.length > 0) {
      const { task } = requestQueue.shift();
      await task();

      // Wait 400ms between requests to avoid triggering proxy rate limits
      await new Promise(resolve => setTimeout(resolve, 400));
    }

    isProcessing = false;
  }

  function enqueue(task) {
    requestQueue.push({ task });
    processQueue();
  }
</script>

<script>
  import { onMount, onDestroy } from 'svelte';
  import { dev } from '$app/environment'; // Detects if the app is in dev mode (ie. running via localhost)
  import { Check, ChevronRight, Copy, HeartPulse, Map, ServerCrash, Swords, Tag, Users, Wifi } from '@lucide/svelte';

  export let ID;

  let info = null;
  let isLoading = true;
  let refreshTimer;

  // Dummy data for development
  const dummyData = {
    name: "Development Server [US-East]",
    version: "1.34.2",
    connect: "127.0.0.1:7777",
    numplayers: 8,
    maxplayers: 16,
    map: "Airport",
    status: true,
    last_update: Math.floor(Date.now() / 1000),
    id: ID
  };

  const targetUrl = `https://api.gamemonitoring.net/servers/${ID}`;
  const proxyUrl = `https://api.cors.lol/?url=${encodeURIComponent(targetUrl)}`;

  async function fetchServerData() {
    // Dev logic (dummyData)
    if (dev) {
      console.log(`[Dev Mode] Skipping API fetch for ID ${ID}. Using dummy data.`);
      info = dummyData;
      isLoading = false;
      return; 
    }

    // Prod logic (queue/fetch)
    enqueue(async () => {
      try {
        const response = await fetch(proxyUrl);

        if (response.status === 429) {
          console.warn(`Rate limited for ID ${ID}. Retrying in 5s...`);
          setTimeout(fetchServerData, 5000);
          return;
        }

        if (!response.ok) throw new Error('Fetch failed');

        const data = await response.json();
        if (data?.response) {
          info = data.response;
          isLoading = false;
          scheduleRefresh(5 * 60 * 1000);
        }
      } catch (err) {
        console.error(`Error fetching ID ${ID}:`, err);
        setTimeout(fetchServerData, 5000);
      }
    });
  }

  function scheduleRefresh(ms) {
    clearTimeout(refreshTimer);
    refreshTimer = setTimeout(fetchServerData, ms);
  }

  onMount(() => {
    fetchServerData();
  });

  onDestroy(() => {
    clearTimeout(refreshTimer);
  });

  $: isOnline = info?.status === true;

  let copied = false;

  async function copyToClipboard(text) {
    if (!text) return;

    try {
      await navigator.clipboard.writeText(text);
      copied = true;
      setTimeout(() => (copied = false), 2000);
    } catch (err) { console.error(err); }
  }

  function timeAgo(unixTimestamp) {
    if (!unixTimestamp) return 'Never';

    const seconds = Math.floor((Date.now() - unixTimestamp * 1000) / 1000);

    if (seconds < 60) return 'Just now';

    const intervals = {
      year: 31536000, month: 2592000, week: 604800, day: 86400, hour: 3600, minute: 60,
    };

    for (let [unit, value] of Object.entries(intervals)) {
      const count = Math.floor(seconds / value);

      if (count >= 1) return `${count} ${unit}${count > 1 ? 's' : ''} ago`;
    }
  }
</script>

<style>
  :global(.animate-sync-pulse) {
    animation: pulse 2.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }
  
  :global(.animate-sync-breathe) {
    animation: breathe 2.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
  }

  :global(.animate-staccato) {
    animation: staccato 2s cubic-bezier(0.45, 0.05, 0.55, 0.95) infinite;
  }

  @keyframes pulse { 
    75%, 100% { transform: scale(1.5); opacity: 0; }
  }

  @keyframes breathe {
    0%, 100% { opacity: 1; }
    50% { opacity: .3; }
  }
</style>

{#if isLoading}
  <div class="flex items-stretch rounded-lg border border-border bg-card overflow-hidden animate-pulse">
    <div class="w-16 sm:w-20 shrink-0 flex items-center justify-center">
      <div class="w-8 h-8 rounded-full bg-muted/20"></div>
    </div>

    <div class="grow py-4 px-4 flex items-center gap-4 min-w-0">
      <div class="flex items-center gap-3 shrink-0 w-1/4 max-w-65">
        <div class="h-5 flex-1 bg-muted/30 rounded"></div>
        <div class="h-4 w-16 bg-muted/20 rounded-full shrink-0"></div>
      </div>

      <div class="flex items-center gap-3 min-w-0">
        <div class="h-6 w-28 bg-muted/20 rounded-md shrink-0"></div>
        <span class="w-1 h-1 rounded-full bg-muted/20 shrink-0"></span>
        <div class="h-4 w-16 bg-muted/20 rounded shrink-0"></div>
        <span class="w-1 h-1 rounded-full bg-muted/20 shrink-0"></span>
        <div class="h-4 w-24 bg-muted/20 rounded shrink-0"></div>
      </div>
    </div>

    <div class="w-12 shrink-0 border-l border-border flex items-center justify-center">
      <div class="w-4 h-4 bg-muted/20 rounded"></div>
    </div>
  </div>
{:else}
  <div class="flex items-stretch rounded-lg border border-border bg-card overflow-hidden transition-all shadow-sm hover:shadow-md">
    <div class="w-16 sm:w-20 shrink-0 flex items-center justify-center bg-transparent">
      <div class="relative flex items-center justify-center">
        {#if isOnline}
          <HeartPulse class="absolute size-6 text-emerald-400 animate-sync-pulse" />
          <HeartPulse class="relative size-6 text-emerald-400 animate-sync-breathe" />
        {:else}
          <ServerCrash class="relative size-6 text-red-500 animate-pulse" />
        {/if}
      </div>
    </div>

    <div class="grow py-4 flex items-center gap-8 min-w-0">
      <h4 class="font-bold text-foreground whitespace-nowrap overflow-hidden text-ellipsis">
        {info.name}
      </h4>

      <div class="flex items-center gap-4 text-xs text-muted-foreground font-mono min-w-0">
        <span class="text-[10px] font-mono px-2 py-0.5 rounded border whitespace-nowrap shrink-0 {info.version ? 'bg-primary/10 text-primary border-primary/30' : 'bg-red-500/10 text-red-500 border-red-500/20'}">
          <div class="flex items-center gap-1.5">
            <Tag size={10} class="opacity-90" />
            <span class="font-bold">{info.version ? info.version : 'Unknown'}</span>
          </div>
        </span>

        <span class="w-1 h-1 rounded-full bg-muted-foreground/20 shrink-0"></span>

        <button on:click={() => copyToClipboard(info.connect)} class="group/copy flex items-center gap-2 px-2.5 py-1 rounded-md border border-border bg-secondary/20 text-muted-foreground hover:text-foreground hover:border-muted-foreground/40 transition-all text-[11px] whitespace-nowrap shrink-0">
          {#if copied}
            <Check size={12} class="text-emerald-500 shrink-0" />
            <span class="text-emerald-500 font-bold">Copied!</span>
          {:else}
            <Wifi size={12} class="opacity-60 group-hover/copy:opacity-100 transition-opacity shrink-0" />
            <span>{info.connect}</span>
            <Copy size={10} class="ml-1 opacity-40 group-hover/copy:opacity-60 shrink-0" />
          {/if}
        </button>

        <span class="w-1 h-1 rounded-full bg-muted-foreground/20 shrink-0"></span>
        
        <div class="flex items-center gap-1 shrink-0 whitespace-nowrap">
          <Users class="w-3.5 h-3.5" /> {info.numplayers}/{info.maxplayers}
        </div>

        <span class="w-1 h-1 rounded-full bg-muted-foreground/20 shrink-0"></span>

        <div class="flex items-center gap-1 truncate max-w-50">
          <Map class="w-3.5 h-3.5 shrink-0" /> 
          <span class="truncate">{info.map}</span>
        </div>

        <span class="w-1 h-1 rounded-full bg-muted-foreground/20 shrink-0"></span>
        
        <div class="flex items-center text-[11px] text-muted-foreground/30 font-medium uppercase tracking-tight leading-none shrink-0 whitespace-nowrap pr-[50px]">
          Heartbeat: {timeAgo(info.last_update)}
        </div>
      </div>
    </div>

    <a href="https://gamemonitoring.net/ground-branch/servers/{info.id}/connect" target="_blank" class="group flex items-center justify-center bg-primary text-primary-foreground border-l border-primary transition-all duration-500 ease-in-out shrink-0 relative overflow-hidden w-42 lg:w-12 lg:bg-transparent lg:text-muted-foreground/60 lg:border-border lg:hover:w-42 lg:hover:bg-primary lg:hover:text-primary-foreground lg:hover:border-primary">
      <div class="flex items-center justify-center transition-all duration-500">
        <span class="font-bold uppercase tracking-widest text-xs whitespace-nowrap transition-all duration-500 max-w-xs opacity-100 ml-0 mr-2 lg:max-w-0 lg:opacity-0 lg:group-hover:max-w-xs lg:group-hover:opacity-100 lg:group-hover:mr-0">
          Play Now
        </span>

        <div class="relative w-4 h-4 flex items-center justify-center shrink-0 transition-all duration-500">
          <div class="absolute inset-0 transition-all duration-500 transform 
                      scale-0 opacity-0 rotate-180 
                      lg:scale-100 lg:opacity-100 lg:rotate-0 
                      lg:group-hover:rotate-180 lg:group-hover:scale-0 lg:group-hover:opacity-0">
            <ChevronRight size={16} />
          </div>

          <div class="absolute inset-0 transition-all duration-500 transform 
                      scale-110 opacity-100 rotate-0 
                      lg:scale-0 lg:opacity-0 lg:-rotate-180 
                      lg:group-hover:rotate-0 lg:group-hover:scale-110 lg:group-hover:opacity-100">
            <Swords size={16} />
          </div>
        </div>
      </div>
    </a>
  </div>
{/if}