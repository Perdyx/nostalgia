<script lang="ts">
    import * as Card from "$lib/components/ui/card/index.js";
    import { Activity, Users, Map as MapIcon, Wifi, CloudFog, ChevronRight, PlugZap } from "@lucide/svelte";
    
    $: isOnline = true;
</script>

<style>
    :global(.animate-ping-slow) { 
        animation: ping 2.5s cubic-bezier(0, 0, 0.2, 1) infinite; 
    }
    
    @keyframes ping {
        75%, 100% {
            transform: scale(2);
            opacity: 0;
        }
    }
</style>

<div class="w-full max-w-[900px] mx-auto py-12">
    <Card.Root class="overflow-hidden border-border bg-card shadow-sm">
        <Card.Header> 
            <div class="flex flex-col items-start text-left">
                <Card.Title class="text-xl font-bold tracking-tight text-card-foreground">
                    Ground Branch
                </Card.Title>
                <div class="flex items-center gap-2 mt-1">
                    <CloudFog class="w-4 h-4 text-orange-500" />
                    <span class="text-sm text-muted-foreground font-medium">
                        Active servers: 1
                    </span>
                </div>
            </div>
        </Card.Header>
        
        <Card.Content>
            <div class="flex flex-col sm:flex-row items-stretch rounded-lg border border-border bg-card overflow-hidden transition-all">
                
                <div class="w-20 flex items-center justify-center py-4 sm:py-0">
                    <div class="relative flex items-center justify-center">
                        {#if isOnline}
                            <Activity class="absolute w-6 h-6 text-emerald-500 animate-ping-slow opacity-50" />
                        {/if}
                        <Activity 
                            class="relative w-6 h-6 transition-colors duration-500
                            {isOnline ? 'text-emerald-500 animate-pulse' : 'text-red-500'}" 
                        />
                    </div>
                </div>
                
                <div class="flex-grow p-4 flex flex-col justify-center">
                    <div class="flex items-center gap-2 mb-1">
                        <h4 class="font-bold text-foreground">Nostalgia</h4>
                        <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-primary/10 text-primary border border-primary/20 ml-1">
                            v1.0.0.0
                        </span>
                    </div>
                    
                    <div class="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground font-mono">
                        <div class="flex items-center gap-1">
                            <Wifi class="w-3.5 h-3.5" /> 172.218.139.3:27051
                        </div>
                        <span class="hidden sm:inline text-muted-foreground/30">•</span>
                        <div class="flex items-center gap-1">
                            <Users class="w-3.5 h-3.5" /> 0/12 Players
                        </div>
                        <span class="hidden sm:inline text-muted-foreground/30">•</span>
                        <div class="flex items-center gap-1">
                            <MapIcon class="w-3.5 h-3.5" /> nv103518412
                        </div>
                    </div>
                </div>
                
                <a 
                    href="https://gamemonitoring.net/ground-branch/servers/11181191/connect" 
                    target="_blank" 
                    class="group flex items-center justify-center 
                    bg-transparent text-muted-foreground/60 border-l border-border
                    hover:bg-primary/90 hover:text-primary-foreground hover:border-primary/90
                    transition-all duration-500 ease-in-out 
                    w-12 hover:w-28 min-h-[50px] sm:min-h-full overflow-hidden"
                >
                    <div class="flex items-center justify-center transition-all duration-500">
                        <span class="max-w-0 opacity-0 group-hover:max-w-[100px] group-hover:opacity-100 transition-all duration-500 font-bold uppercase tracking-widest text-xs whitespace-nowrap">
                            Join
                        </span>
                        
                        <div class="relative w-4 h-4 flex items-center justify-center flex-shrink-0 transition-all duration-500 group-hover:ml-2">
                            <div class="absolute inset-0 transition-all duration-500 transform 
                                group-hover:rotate-180 group-hover:scale-0 group-hover:opacity-0">
                                <ChevronRight size={16} strokeWidth={3} />
                            </div>
                            
                            <div class="absolute inset-0 transition-all duration-500 transform scale-0 opacity-0 rotate-[-180deg]
                                group-hover:rotate-0 group-hover:scale-110 group-hover:opacity-100">
                                <PlugZap size={16} strokeWidth={2.5} />
                            </div>
                        </div>
                    </div>
                </a>
            </div>
        </Card.Content>
    </Card.Root>
</div>