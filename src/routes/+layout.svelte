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
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>

<ModeWatcher />

<NavigationMenu.Root class="max-w-full w-full justify-start px-4 py-2 border-b">
    <NavigationMenu.List class="max-w-full w-full flex items-center">
        <NavigationMenu.Item>
            <NavigationMenu.Link class="font-medium text-[16px]">Servers</NavigationMenu.Link>
        </NavigationMenu.Item>
        <NavigationMenu.Item>
            <NavigationMenu.Link class="font-medium text-[16px]">About</NavigationMenu.Link>
        </NavigationMenu.Item>
    </NavigationMenu.List>

    <div class="ml-auto"></div>

    <Button onclick={toggleMode} variant="outline" size="icon">
        <SunIcon class="h-[1.2rem] w-[1.2rem] scale-100 rotate-0 transition-all! dark:scale-0 dark:-rotate-90"/>
        <MoonIcon class="absolute h-[1.2rem] w-[1.2rem] scale-0 rotate-90 transition-all! dark:scale-100 dark:rotate-0"/>
        <span class="sr-only">Toggle theme</span>
    </Button>
</NavigationMenu.Root>

{@render children?.()}