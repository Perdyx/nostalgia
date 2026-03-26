<script>
    import './layout.css';
    import favicon from '$lib/assets/favicon.svg';
    
    import SunIcon from "@lucide/svelte/icons/sun";
    import MoonIcon from "@lucide/svelte/icons/moon";
    
    import { ModeWatcher } from "mode-watcher";
    import * as NavigationMenu from "$lib/components/ui/navigation-menu/index.js";
    import { toggleMode } from "mode-watcher";
    import { Button } from "$lib/components/ui/button/index.js";
    
    let { children } = $props();
    
    import { Minimize, Swords } from "@lucide/svelte";
    const rows = Array(60).fill(0);
    const cols = Array(120).fill(0);
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>
<ModeWatcher />

<NavigationMenu.Root class="max-w-full w-full justify-start px-8 py-4 sticky top-0 z-50 bg-background border-b">
    <NavigationMenu.List class="max-w-full w-full flex items-center">
        <NavigationMenu.Item>
            <NavigationMenu.Link class="font-medium text-[16px]">LOGO</NavigationMenu.Link>
        </NavigationMenu.Item>
    </NavigationMenu.List>
    
    <div class="ml-auto"></div>
    
    <Button onclick={toggleMode} variant="outline" size="icon">
        <SunIcon class="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all! dark:scale-0 dark:-rotate-90"/>
        <MoonIcon class="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all! dark:scale-100 dark:rotate-0"/>
    </Button>
</NavigationMenu.Root>

<div class="relative min-h-screen w-full overflow-hidden bg-background">
    <div class="absolute left-0 top-0 flex h-[200vh] w-[200vw] -ml-[50vw] -mt-[50vh] rotate-12 flex-col justify-center gap-8 pointer-events-none">
        {#each rows as _, rowIndex}
            <div class="flex w-full justify-center gap-8">
                {#each cols as _, colIndex}
                    <div class="text-foreground/10 dark:text-foreground/20">
                        {#if (rowIndex + colIndex) % 2 === 0}
                            <Swords size={24} strokeWidth={1.5} />
                        {:else}
                            <Minimize size={24} strokeWidth={1.5} />
                        {/if}
                    </div>
                {/each}
            </div>
        {/each}
    </div>

    <div class="relative z-10 flex flex-col gap-8 w-full max-w-[900px] mx-auto py-12 px-4">
        {@render children?.()}
    </div>
</div>