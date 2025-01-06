def test_main(capsys):
    from hello_world.main import main

    main()
    captured = capsys.readouterr()
    assert captured.out == "Hello, World!\n"
