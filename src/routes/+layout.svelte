<script>
    // Styles & Assets
    import "./layout.css";
    import favicon from "$lib/assets/favicon.svg";
    import hero1 from "$lib/assets/hero1.jpg";
    import hero2 from "$lib/assets/hero2.png";

    // Shadcn UI Components
    import * as NavigationMenu from "$lib/components/ui/navigation-menu/index.js";
    import { Button } from "$lib/components/ui/button/index.js";

    // Icons
    import { Copyright, GamepadDirectional, Flame, ChevronLeft, ChevronRight } from "@lucide/svelte";
    import { onMount } from "svelte";

    let { children } = $props();
    const rows = Array(60).fill(0);
    const cols = Array(120).fill(0);

    // Slideshow state
    let currentImageIndex = $state(0);
    const images = [hero1, hero2];
    let interval;

    const startTimer = () => {
        clearInterval(interval);
        interval = setInterval(() => { currentImageIndex = (currentImageIndex + 1) % images.length; }, 7500);
    };

    const next = () => { currentImageIndex = (currentImageIndex + 1) % images.length; startTimer(); };
    const prev = () => { currentImageIndex = (currentImageIndex - 1 + images.length) % images.length; startTimer(); };
    const goTo = (i) => { currentImageIndex = i; startTimer(); };

    onMount(() => {
        startTimer();
        return () => clearInterval(interval);
    });
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>

<NavigationMenu.Root class="max-w-full w-full justify-start px-8 py-4 sticky top-0 z-50 bg-background border-b">
    <NavigationMenu.List class="max-w-full w-full flex items-center">
        <NavigationMenu.Item><NavigationMenu.Link class="font-medium text-[16px]">LOGO</NavigationMenu.Link></NavigationMenu.Item>
    </NavigationMenu.List>
</NavigationMenu.Root>

<div class="relative flex flex-col items-center">
    <section class="relative w-full h-175 overflow-hidden">
        <div class="absolute inset-0 z-0 w-full h-full" style:mask-image="linear-gradient(to bottom, black calc(100% - 300px), transparent 100%)" style:-webkit-mask-image="linear-gradient(to bottom, black calc(100% - 300px), transparent 100%)">
            {#each images as img, i}<img src={img} alt="Hero {i}" class="absolute inset-0 w-full h-full object-cover object-center transition-opacity duration-1500 {i === currentImageIndex ? 'opacity-100' : 'opacity-0'}" />{/each}
            <div class="absolute inset-0 bg-linear-to-r from-black to-transparent"></div>
        </div>
        
        <div class="relative z-10 container mx-auto h-full flex flex-col justify-center px-6 lg:px-12">
            <div class="max-w-2xl space-y-6">
                <h1 class="text-5xl font-extrabold tracking-wide text-foreground">Nostalgia Network</h1>
                <p class="text-lg text-muted-foreground leading-relaxed">Welcome to the Nostalgia game network! All of our servers are privately owned, facilitated, and maintained and are backed up nightly at midnight (PST). Please join our Discord server to read the rules, get notified about changes, and join the growing community!</p>
                <div class="pt-4"><Button size="lg" class="px-8 py-6 text-lg transition-transform" href="https://discord.gg/SFwzAnRjvv">Join the Discord!</Button></div>
            </div>
        </div>

        <div class="absolute bottom-12 left-1/2 -translate-x-1/2 z-20 flex items-center gap-4 px-4 py-2">
            <button onclick={prev} class="text-white/50 hover:text-primary transition-colors"><ChevronLeft size={20} /></button>

            <div class="flex gap-2.5">
                {#each images as _, i}
                    <button onclick={() => goTo(i)} class="size-2 rotate-45 transition-all {i === currentImageIndex ? 'scale-100 bg-primary' : 'scale-75 bg-transparent border border-white/50 hover:border-primary'}"></button>
                {/each}
            </div>

            <button onclick={next} class="text-white/50 hover:text-primary transition-colors"><ChevronRight size={20} /></button>
        </div>
    </section>

    <div class="w-full relative z-10" style:margin-top="-50px" style:mask-image="linear-gradient(to top, black calc(100% - 150px), transparent 100%)" style:-webkit-mask-image="linear-gradient(to top, black calc(100% - 150px), transparent 100%)">
        <div class="relative min-h-screen w-full overflow-hidden bg-background">
            <div class="absolute left-0 top-0 flex h-[200vh] w-[200vw] -ml-[50vw] -mt-[50vh] rotate-12 flex-col justify-center gap-8 pointer-events-none">
                {#each rows as _, rowIndex}
                    <div class="flex w-full justify-center gap-8">
                        {#each cols as _, colIndex}
                            <div class="text-foreground/10">{#if (rowIndex + colIndex) % 2 === 0}<Flame size={32} strokeWidth={1} />{:else}<GamepadDirectional size={32} strokeWidth={1} />{/if}</div>
                        {/each}
                    </div>
                {/each}
            </div>
            <div class="relative z-10 flex flex-col gap-8 w-full max-w-400 mx-auto py-48 px-4">{@render children?.()}</div>
        </div>
    </div>
</div>

<footer class="w-full border-t bg-background py-8 text-center">
    <div class="container mx-auto flex flex-col items-center gap-2">
        <div class="flex items-center gap-1 text-sm text-muted-foreground">
            <span>Built with <a href="https://shadcn-svelte.com/" target="_blank" class="font-medium underline underline-offset-4">shadcn-svelte</a>.</span>
            <span>Code licensed under <a href="https://github.com/Perdyx/nostalgia/blob/main/LICENSE" target="_blank" class="font-medium underline underline-offset-4">MIT License</a>.</span>
        </div>
        <div class="flex items-center gap-1.5 text-xs text-muted-foreground/60"><Copyright class="size-3" /><span>{new Date().getFullYear()}</span></div>
    </div>
</footer>