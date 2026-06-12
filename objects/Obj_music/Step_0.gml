if (global.musica)
{
    if (audio_is_paused(som_id))
    {
        audio_resume_sound(som_id);
    }
}
else
{
    if (!audio_is_paused(som_id))
    {
        audio_pause_sound(som_id);
    }
}