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
  import { Activity, Wifi, Users, Map, ChevronRight, PlugZap, Copy, Check, Tag, ServerCrash } from '@lucide/svelte';

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

  @keyframes staccato {
    0%, 35%   { opacity: 1; }
    55%, 85%  { opacity: 0.3; }
    100%      { opacity: 1; }
  }
</style>

{#if isLoading}
  <div class="flex flex-col sm:flex-row items-stretch rounded-lg border border-border bg-card overflow-hidden animate-pulse">
    <div class="w-20 flex items-center justify-center py-4 sm:py-0">
      <div class="w-8 h-8 rounded-full bg-muted/20"></div>
    </div>

    <div class="grow p-3 sm:p-4 flex flex-col justify-center min-w-0">
      <div class="flex items-center gap-3 mb-3">
        <div class="h-5 w-48 bg-muted/30 rounded"></div>
        <div class="h-4 w-16 bg-muted/20 rounded-full"></div>
      </div>

      <div class="flex flex-wrap items-center gap-x-3 gap-y-1.5 mt-1">
        <div class="h-6 w-32 bg-muted/20 rounded-md"></div>
        <span class="hidden sm:inline-block w-1 h-1 rounded-full bg-muted/20"></span>
        <div class="h-4 w-16 bg-muted/20 rounded"></div>
        <span class="hidden sm:inline-block w-1 h-1 rounded-full bg-muted/20"></span>
        <div class="h-4 w-24 bg-muted/20 rounded"></div>
      </div>
    </div>

    <div class="hidden md:flex items-center justify-center pr-8">
      <span class="text-xs font-bold tracking-[0.2em] text-muted-foreground/40 uppercase select-none">
        Loading server data...
      </span>
    </div>

    <div class="w-12 flex items-center justify-center">
      <div class="w-4 h-4 bg-muted/20 rounded"></div>
    </div>
  </div>
{:else}
  <div class="flex flex-col sm:flex-row items-stretch rounded-lg border border-border bg-card overflow-hidden transition-all shadow-sm hover:shadow-md">
    
    <div class="w-20 flex items-center justify-center py-4 sm:py-0 bg-transparent">
      <div class="relative flex items-center justify-center">
        {#if isOnline}
          <Activity class="absolute w-6 h-6 text-emerald-400 animate-sync-pulse" />
          <Activity class="relative w-6 h-6 text-emerald-400 animate-sync-breathe" />
        {:else}
          <ServerCrash class="relative w-6 h-6 text-red-500 animate-staccato" />
        {/if}
      </div>
    </div>

    <div class="grow p-3 sm:p-4 flex flex-col justify-center min-w-0">
      <div class="flex items-center gap-3 mb-2 w-full">
        <h4 class="font-bold text-foreground whitespace-nowrap overflow-hidden text-ellipsis">
          {info.name}
        </h4>
        <span class="text-[10px] font-mono px-2 py-0.5 rounded border whitespace-nowrap shrink-0 
          {info.version 
            ? 'bg-primary/10 text-primary border-primary/30' 
            : 'bg-red-500/10 text-red-500 border-red-500/20'}">
          <div class="flex items-center gap-1.5">
            <Tag size={10} strokeWidth={2.5} class="opacity-90" />
            <span class="font-bold">{info.version ? info.version : 'Unknown'}</span>
          </div>
        </span>
      </div>

      <div class="flex flex-wrap items-center gap-x-3 gap-y-1.5 text-xs text-muted-foreground font-mono">
        <button 
          on:click={() => copyToClipboard(info.connect)}
          class="group/copy flex items-center gap-2 px-2.5 py-1 rounded-md border border-border bg-secondary/20 text-muted-foreground hover:text-foreground hover:border-muted-foreground/40 transition-all text-[11px]"
        >
          {#if copied}
            <Check size={12} class="text-emerald-500" />
            <span class="text-emerald-500 font-bold">Copied!</span>
          {:else}
            <Wifi size={12} class="opacity-60 group-hover/copy:opacity-100 transition-opacity" />
            <span>{info.connect}</span>
            <Copy size={10} class="ml-1 opacity-40 group-hover/copy:opacity-60" />
          {/if}
        </button>

        <span class="hidden sm:inline-block w-1 h-1 rounded-full bg-muted-foreground/20 mx-0.5 self-center"></span>
        
        <div class="flex items-center gap-1">
          <Users class="w-3.5 h-3.5" /> {info.numplayers}/{info.maxplayers}
        </div>

        <span class="hidden sm:inline-block w-1 h-1 rounded-full bg-muted-foreground/20 mx-0.5 self-center"></span>

        <div class="flex items-center gap-1 truncate max-w-30 sm:max-w-none">
          <Map class="w-3.5 h-3.5" /> {info.map}
        </div>

        <span class="hidden sm:inline-block w-1 h-1 rounded-full bg-muted-foreground/20 mx-0.5 self-center"></span>
        
        <div class="flex items-center text-[11px] text-muted-foreground/30 font-medium uppercase tracking-tight leading-none">
          {timeAgo(info.last_update)}
        </div>
      </div>
    </div>

    <a
      href="https://gamemonitoring.net/ground-branch/servers/{info.id}/connect"
      target="_blank"
      class="group flex items-center justify-center bg-transparent text-muted-foreground/60 border-l border-border hover:bg-primary hover:text-primary-foreground hover:border-primary transition-all duration-500 ease-in-out w-12 hover:w-28 min-h-11 sm:min-h-full overflow-hidden shrink-0"
    >
      <div class="flex items-center justify-center transition-all duration-500">
        <span class="max-w-0 opacity-0 group-hover:max-w-25 group-hover:opacity-100 transition-all duration-500 font-bold uppercase tracking-widest text-xs whitespace-nowrap">
          Join
        </span>
        <div class="relative w-4 h-4 flex items-center justify-center shrink-0 transition-all duration-500 group-hover:ml-2">
          <div class="absolute inset-0 transition-all duration-500 transform group-hover:rotate-180 group-hover:scale-0 group-hover:opacity-0">
            <ChevronRight size={16} strokeWidth={3} />
          </div>
          <div class="absolute inset-0 transition-all duration-500 transform scale-0 opacity-0 -rotate-180 group-hover:rotate-0 group-hover:scale-110 group-hover:opacity-100">
            <PlugZap size={16} strokeWidth={2.5} />
          </div>
        </div>
      </div>
    </a>
  </div>
{/if}